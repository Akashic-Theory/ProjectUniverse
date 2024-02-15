//
// Created by Patrick on 10/7/2023.
//

#include "Pathfinding.h"

godot::PackedVector3Array Pathfinding::trim_path (const godot::PackedVector3Array& path, const double maxDistance) {
    godot::PackedVector3Array newPath;
    double distance = 0.0;
    double lastDistance = 0.0;

    if (path.size() == 0) {
        return newPath;
    }

    newPath.append(path[0]);
    for (int i = 1; i < path.size(); i++) {
        distance += path[i - 1].distance_to(path[i]);

        if (distance > maxDistance) {
            double remainingDistance = abs(maxDistance - lastDistance);

            newPath.append(path[i - 1] +
                            (path[i] - path[i - 1]).limit_length(remainingDistance));
            break;
        }

        lastDistance = distance;
        newPath.append(path[i]);
    }

    return newPath;
}

double Pathfinding::count_path (const godot::PackedVector3Array& path) {
    double distance = 0.0;

    for (int i = 1; i < path.size(); i++) {
        distance += path[i - 1].distance_to(path[i]);
    }

    return distance;
}

void Pathfinding::_bind_methods() {
    using namespace godot;
    ClassDB::bind_static_method(Pathfinding::get_class_static(),
                                D_METHOD("trim_path", "path", "max_distance"),
                                &Pathfinding::trim_path);
    ClassDB::bind_static_method(Pathfinding::get_class_static(),
                                D_METHOD("count_path", "path"),
                                &Pathfinding::count_path);
}
